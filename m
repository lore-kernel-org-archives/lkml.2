Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab2IJXUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:20:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52518 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2IJXUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:20:09 -0400
Date: Tue, 11 Sep 2012 00:24:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/3] mei: struct mei_message_data doesn't have
 to be packed
Message-ID: <20120911002449.3aa7728a@pyramind.ukuu.org.uk>
In-Reply-To: <1347313402-24606-2-git-send-email-tomas.winkler@intel.com>
References: <1347313402-24606-1-git-send-email-tomas.winkler@intel.com>
	<1347313402-24606-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012 00:43:21 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/mei_dev.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
> index 96d3e79..adb35fb 100644
> --- a/drivers/misc/mei/mei_dev.h
> +++ b/drivers/misc/mei/mei_dev.h
> @@ -140,7 +140,7 @@ enum mei_cb_major_types {
>  struct mei_message_data {
>  	u32 size;
>  	unsigned char *data;
> -} __packed;
> +};

Explanation would be useful especially for this one. The others are
obvious although a one line comment would still be good form perhaps.
