Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1DZOk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:40:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:57110 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1DZOk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:40:27 -0400
Message-ID: <4DB6D959.6090008@suse.cz>
Date: Tue, 26 Apr 2011 16:40:25 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix sed error in export_report.pl
References: <4DB608EE.1060502@verizon.net>
In-Reply-To: <4DB608EE.1060502@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.4.2011 01:51, Peter Foley wrote:
> This patch fixes a sed error in export_report.pl by escaping a $.
>
> Signed-off-by: Peter Foley<pefoley2@verizon.net>
> ---
>   scripts/export_report.pl |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/export_report.pl b/scripts/export_report.pl
> index 04dce7c..91fa5a2 100644
> --- a/scripts/export_report.pl
> +++ b/scripts/export_report.pl
> @@ -50,7 +50,7 @@ sub usage {
>    sub collectcfiles {
>       my @file
> -	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko$/.mod.c/`;
> +	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko\$/.mod.c/`;

Please enclose the argument in single quotes instead.

Michal
