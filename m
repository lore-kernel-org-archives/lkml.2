Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1CPJfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:35:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38645 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1CPJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=h1FEHt2FT83mPfeiqCzBTGFVRuqulEjL6gO1HH2si0COy23ERJBrQT6ezZztxtWB06
         OiwOcxnb4QP+SyUyX6R9rBwgZtDT6nZhApdN+8B+3dNNWJ15gF6zXBuSmCSbGy/5Iept
         f1n9OOQccNbzmytG8nbm4SvRvilVau7V658Jg=
MIME-Version: 1.0
Date: Wed, 16 Mar 2011 15:05:29 +0530
Message-ID: <AANLkTimP9-SK3YCwgsS8USEYNExFQTQLPYXKi+RUbBT4@mail.gmail.com>
Subject: Query
From: snmp snmp <snmp.ml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,
     Me and my friends are working on a new concept.
     Idea is to run different kernels on different cores in a
multicore architecture. Each kernel is performing logically different
tasks. We believe to improve the cache performance and reduce cpu idle
time. This concept can be applied to filers , graphics processing
systems , embedded systems.
     Our implementation is on Intel core 2 duo machine. So far our
implementation includes running two kernels simultaneously (one on
each core) , handling hard-disk on one core and ethernet on another
core so as to divide the network and disk subsystem.

     But here we are unable to measure the performance. Can u please
suggest any method to measure the performance in terms of throughput
and response time?

     Thank you.
