Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab1FVLMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:12:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33435 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1FVLMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ebWG+wxyzc2uYtfnBc2rRy/ujpkTEwGpoRxo3HfFPlN7UM5RjBOqLUmdc+NTQPm4e5
         nEavT48HMKAJWfZTJERcU+tYcxqmfNnuIfCaG2I6yhorlW27CKE64qZKs+Ved3YN3RUS
         VO246tP1uN4VBVCfgOgbEPxVOo9sD5Z/SLrDU=
Date: Wed, 22 Jun 2011 14:11:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stefan Weil <weil@mail.berlios.de>,
        Xiaochen Wang <wangxiaochen0@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chosrova <dada2372@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers:rtl8187se:remove the use of obsolete
 create_workqueue in ieee80211_softmac.c
Message-ID: <20110622111111.GK14591@shale.localdomain>
References: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
 <1308732001.2198.0.camel@Tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1308732001.2198.0.camel@Tux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 04:40:01PM +0800, Wanlong Gao wrote:
> On 日, 2011-06-19 at 18:11 +0800, Wanlong Gao wrote:
> Any comments?

It takes a while to get to patches.  If it's been two weeks and you
haven't heard anything, then ask again.  Otherwise just assume that
they're going to be applied.

regards,
dan carpenter
