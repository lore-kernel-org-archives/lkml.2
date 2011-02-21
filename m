Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab1BUXmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:42:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1BUXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:42:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: oleg@redhat.com, paulmck@linux.vnet.ibm.com, vgoyal@redhat.com
Subject: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit update code
Date: Mon, 21 Feb 2011 18:42:48 -0500
Message-Id: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Couple of throttle fixes seem to have fallen through cracks.

https://lkml.org/lkml/2010/12/15/331

I am reposting it for inclusion. Please let me know if you have any concerns.
Oleg and Paul acked the patch in the past so I am retaining their Reviewed-by:
lines.

Thanks
Vivek

Vivek Goyal (2):
  blk-throttle: process limit change only through one function
  blk-throttle: Some cleanups and race fixes in limit update code

 block/blk-throttle.c |  104 ++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 63 deletions(-)
