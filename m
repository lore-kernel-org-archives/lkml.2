Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0IMP46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:56:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0IMP45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:56:57 -0400
Message-ID: <4C8E49C8.6090003@suse.cz>
Date: Mon, 13 Sep 2010 17:56:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]scripts/kconfig/gconf.glade Update broken web addresses.
References: <1284184584-8647-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1284184584-8647-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.9.2010 07:56, Justin P. Mattock wrote:
> Below fixes a broken web address. Note: not sure if this is correct
> or not.. Let me know..
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  scripts/kconfig/gconf.glade |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
> index d52b0a7..8092dcf 100644
> --- a/scripts/kconfig/gconf.glade
> +++ b/scripts/kconfig/gconf.glade
> @@ -1,5 +1,5 @@
>  <?xml version="1.0" standalone="no"?> <!--*- mode: xml -*-->
> -<!DOCTYPE glade-interface SYSTEM "http://glade.gnome.org/glade-2.0.dtd">
> +<!DOCTYPE glade-interface SYSTEM "http://library.gnome.org/devel/libglade/unstable/libglade-dtd.html">

This URL does not host the dtd itself, so we can as well remove the
DOCTYPE declaration alltogether. I guess libglade validates the file
against it's own schema anyway.

Michal
