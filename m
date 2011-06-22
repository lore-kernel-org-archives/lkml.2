Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1FVKFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:05:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35677 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1FVKFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MQjW4cvduUY82gK5GAdVVskztly1pfxzEfLbP5VY1Dpfb/6qhKfcsp27njf/ANF98t
         P5G/XOasZK2pzx8qgwOOiYPqeGAGbV/MOgjNV2hwDW190CvEJYxoOk7LfyDs0j19m6B2
         pqasNTrDBAW7aXZVXrjBNl+6hF4LJuuv+XfzY=
MIME-Version: 1.0
In-Reply-To: <1308640714-17961-3-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-3-git-send-email-ohad@wizery.com>
Date: Wed, 22 Jun 2011 11:05:41 +0100
Message-ID: <BANLkTimAf9EqSX-yHh_0RPaeewndOyNUYA@mail.gmail.com>
Subject: Re: [RFC 2/8] remoteproc: add omap implementation
From: Will Newton <will.newton@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 8:18 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> +/* bootaddr isn't needed for the dual M3's */
> +static inline int omap_rproc_start(struct rproc *rproc, u64 bootaddr)

> +static inline int omap_rproc_stop(struct rproc *rproc)

These two functions don't need to be inline as far as I can see.

> +static struct rproc_ops omap_rproc_ops = {
> +       .start = omap_rproc_start,
> +       .stop = omap_rproc_stop,
> +};
