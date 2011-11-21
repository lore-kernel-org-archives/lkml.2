Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1KUUII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:08:08 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47246 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1KUUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:08:04 -0500
Message-ID: <1321905937.6445.3.camel@work-vm>
Subject: Re: [PATCH 1/2] merge_config.sh: use signal names compatible with
 dash and bash
From: John Stultz <john.stultz@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, gthelen@google.com,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Richard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
Date: Mon, 21 Nov 2011 12:05:37 -0800
In-Reply-To: <591b0f764fd9eb0bc7873ef775052cb038484ae7.1321904550.git.dvhart@linux.intel.com>
References: <1321567131.25715.32.camel@work-vm>
	 <591b0f764fd9eb0bc7873ef775052cb038484ae7.1321904550.git.dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112120-7282-0000-0000-000004070708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 11:42 -0800, Darren Hart wrote:
> The SIGHUP SIGINT and SIGTERM names caused failures when running
> merge_config.sh with the dash shell. Dropping the "SIG" component
> makes the script work in both bash and dash.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Acked-by: John Stultz <john.stultz@linaro.org>

> ---
>  scripts/kconfig/merge_config.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
> index 890276b..b91015d 100755
> --- a/scripts/kconfig/merge_config.sh
> +++ b/scripts/kconfig/merge_config.sh
> @@ -24,7 +24,7 @@ clean_up() {
>         rm -f $TMP_FILE
>         exit
>  }
> -trap clean_up SIGHUP SIGINT SIGTERM
> +trap clean_up HUP INT TERM
> 
>  usage() {
>  	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"


