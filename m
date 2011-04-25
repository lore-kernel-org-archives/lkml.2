Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1DYWAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:00:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1DYWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:00:20 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 054/173] acer-wmi: Fix capitalisation of GUID
Date: Mon, 25 Apr 2011 23:00:13 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38.3cc; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20110425200235.342580584@pcw.home.local>
In-Reply-To: <20110425200235.342580584@pcw.home.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104252300.14068.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 Apr 2011 21:03:26 Willy Tarreau wrote:
> 2.6.27.59-stable review patch.  If anyone has any objections, please let us
> know.

Nack - this caused https://bugzilla.kernel.org/show_bug.cgi?id=32862

Either don't apply this patch, or you'll need to also apply the subsequent fix 
up at the same time (I don't know if that's gone upstream yet?).

-Carlos

> 
> ------------------
> 
> From: Matthew Garrett <mjg@redhat.com>
> 
> commit bbb706079abe955a9e3f208f541de97d99449236 upstream.
> 
> 6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3 needs to be
> 6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3 to match the hardware alias.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/platform/x86/acer-wmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/misc/acer-wmi.c
> +++ b/drivers/misc/acer-wmi.c
> @@ -90,7 +90,7 @@ struct acer_quirks {
>   */
>  #define AMW0_GUID1		"67C3371D-95A3-4C37-BB61-DD47B491DAAB"
>  #define AMW0_GUID2		"431F16ED-0C2B-444C-B267-27DEB140CF9C"
> -#define WMID_GUID1		"6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3"
> +#define WMID_GUID1		"6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3"
>  #define WMID_GUID2		"95764E09-FB56-4e83-B31A-37761F60994A"
> 
>  MODULE_ALIAS("wmi:67C3371D-95A3-4C37-BB61-DD47B491DAAB");
