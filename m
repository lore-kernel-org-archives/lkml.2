Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1FOOna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:43:30 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33459 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521Ab1FOOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:43:28 -0400
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de,
        stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jun 2011 10:43:25 -0400
Message-ID: <1308149005.2616.10.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 17:16 +0900, Nao Nishijima wrote:
> Allow users to set the preferred name of device via sysfs interface.
> 
> (Exsample) sda -> foo
> # echo foo > /sys/block/sda/preferred_name
> 
> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>

So, as I said previously, I think this needs to be in struct device not
struct gendisk.   It will be an easier infrastructure to use and it
easily generalises to our other naming problems (like net).

James


