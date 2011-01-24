Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab1AXFVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 00:21:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63871 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1AXFVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 00:21:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RJ84p4BZ+9am3IxcFOtFiqY84MbDfr7PrH+EOj+PuShhUqeEGRf4NeXUyrpGt/qr4s
         FssE3WCNItRCOYbgyrMJP9Uv9kR1uETOWjEfMAY3nEvzH3nZFsfibczISfgnEkeH3Myt
         LxOpSiF/8BMVdirQFqmLl5/xgz7/uZqpN7bcI=
Date: Mon, 24 Jan 2011 13:20:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Dick Streefland <dick@streefland.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [PATCH] scripts/extract-ikconfig: add xz compression support
Message-ID: <20110124052053.GD6971@cr0.nay.redhat.com>
References: <20110123234457.GB2321@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123234457.GB2321@streefland.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 12:44:57AM +0100, Dick Streefland wrote:
>Add support for kernels compressed with xz to the extract-ikconfig script.
>
>Signed-off-by: Dick Streefland <dick@streefland.net>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
