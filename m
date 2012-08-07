Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2HHJBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:01:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881Ab2HHJBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:01:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 0/4] PM / shmobile: Specify PM domain and device latency information directly
Date: Wed, 8 Aug 2012 00:26:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201207212349.18294.rjw@sisk.pl>
In-Reply-To: <201207212349.18294.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208080026.01738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Saturday, July 21, 2012, Rafael J. Wysocki wrote:
> Hi all,
> 
> The following patchset is on top of the previous one at:
> 
> https://lkml.org/lkml/2012/7/16/399
> 
> Generally speaking, it adds code for the direct specification of various
> PM domain and device latencies used by PM QoS to the SH7372 SoC and
> Mackerel board and suggests a mechanism for reading that information from
> device trees.

Since I haven't received any comments, I suppose everyone is OK with these
patches, except for the DT one that depended on another DT patch that was
rejected.  Thus, a regular (non-RFC) submission follows.

The patches are on top of this patch series posted yesterday:

http://marc.info/?l=linux-pm&m=134429494917435&w=4

Thanks,
Rafael

