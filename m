Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1FOLC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:02:57 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:10763 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1FOLCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:02:54 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jun 2011 12:02:50 +0100
Subject: kernel 2.6.39 iop-adma pq-zero-sum self-test failed
Thread-Topic: kernel 2.6.39 iop-adma pq-zero-sum self-test failed
Thread-Index: AcwrS8SoJkZKC4RWQACkNNMyHj+Fpg==
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C7785750E@gretna.indigovision.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that I have configured everything correctly for the iop-adma
acceleration on iop13xx, using kernel 2.6.39, but I notice that the pq
self test is failing:

iop-adma iop-adma.0: Intel(R) IOP: ( xor xor_val fill cpy intr )
iop-adma iop-adma.1: Intel(R) IOP: ( xor xor_val fill cpy intr )
iop-adma iop-adma.2: Self-test pq-zero-sum failed to validate: 1

The relevant bits from the kernel configuration are:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_RAID_ATTRS=m
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_RAID6_PQ=y

Is this a known issue?  We have previously been using the iop-adma
acceleration on 2.6.26, but this was prior to the pq self-test being
added.


Kind Regards,

Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/index.php/en/news.html
