Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2KFUpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:45:39 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63345 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2KFUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:45:36 -0500
MIME-Version: 1.0
Date: Tue, 6 Nov 2012 21:45:35 +0100
Message-ID: <CAF-VNaq0P+UaUgEGGDy2+CHaSXCQa7cHVGimrxOTxWXT20rOog@mail.gmail.com>
Subject: new sched options
From: Lars Segerlund <lars.segerlund@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 The options schedule for power and schedule for powersave are in my
opinion quite stupid.

 The real use cases are packing on scheduler domains, symetric
multithreading, asymetric packing and over commit on threads or cores
?

 So where are the options like sched_mc, sched_smt and asymetric
packing ? The patch for controlling overcommit on sched mc was very
usefull.

 it's very interesting to use some of these options on the fly, both
for embedded and for datacenter usage.

 For embedded it's interesting to free up a core for RT or to keep the
system in it's  thermal range, or to keep the power consumption low,
but you need parameters for some use cases to play with.

 For the datacenter it's vital to be able to consolidate and control
the load and thermal.

 I don't mind the performance or powersave option, but I miss a sysfs
entry to specify stuff like packing, overcommit and such

 I feel like it's an attempt to simplify something which is both
really hard and has many nuances, no one size fit's all.

 / just my two cents .... Lars Segerlund.
