Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378Ab1ETPvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:51:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab1ETPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lSvMKwQJs41tM2medCeAkfLbKffzLt3w2+BGXqokgh5Mg7jdu1dRkQ50CBxQeFYqZy
         70SDCGrRLQ+DB4PFeHLzbXiSW32mM+lG++Pbc+TaNa/a+Y6DNTge27aStYJXvFpgNb1X
         Ix26tHTFFDDTmVpTWFvxK/IziB0tiBTZE7XI0=
Date: Fri, 20 May 2011 19:51:36 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Rodolfo Giometti <giometti@linux.it>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bq27x00_battery: Name of cycle count property
Message-ID: <20110520155136.GE18099@oksana.dev.rtsoft.ru>
References: <BANLkTik8RDOP3Z2eYqQknEZXBNeWtvFLhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik8RDOP3Z2eYqQknEZXBNeWtvFLhw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 11:59:35PM +0200, Pali Rohár wrote:
> This patch fix using correct property POWER_SUPPLY_PROP_CYCLE_COUNT
> for cycle count instead POWER_SUPPLY_PROP_CHARGE_COUNTER
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Pali, thanks a lot!

This is now applied.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
