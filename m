Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0IQO5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:57:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:59814 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab0IQO5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:57:08 -0400
Message-ID: <4C9381C2.7050608@suse.cz>
Date: Fri, 17 Sep 2010 16:57:06 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scripts/kconfig/gconf.glade Update broken web addresses.
References: <1284407756-4195-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1284407756-4195-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.9.2010 21:55, Justin P. Mattock wrote:
> As discussed, remove the DOCTYPE declaration since libglade validates
> the file against itself..
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/kconfig/gconf.glade |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
> index d52b0a7..aa483cb 100644
> --- a/scripts/kconfig/gconf.glade
> +++ b/scripts/kconfig/gconf.glade
> @@ -1,5 +1,4 @@
>  <?xml version="1.0" standalone="no"?> <!--*- mode: xml -*-->
> -<!DOCTYPE glade-interface SYSTEM "http://glade.gnome.org/glade-2.0.dtd">

Applied.

Michal
