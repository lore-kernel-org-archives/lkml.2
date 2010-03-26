Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0CZNPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:15:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0CZNPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:15:40 -0400
Message-ID: <4BACB37A.20804@suse.cz>
Date: Fri, 26 Mar 2010 14:15:38 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-2.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/16] Scripts lex.c: remove extra spaces
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net> <1269537767-7553-12-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1269537767-7553-12-git-send-email-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.3.2010 18:22, Andrea Gelmini wrote:
> scripts/genksyms/lex.c: deleted extra spaces
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  scripts/genksyms/lex.c_shipped |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
> index 2ac23bc..5682dfd 100644
> --- a/scripts/genksyms/lex.c_shipped
> +++ b/scripts/genksyms/lex.c_shipped
> @@ -27,7 +27,7 @@
>  /* %endif */
>  
>  /* %if-c-only */
> -    
> +
>  /* %endif */

This is a generated file, I don't think there is value in manually
fixing coding style issues in it, each subsequent update would overwrite
the changes.

Michal
