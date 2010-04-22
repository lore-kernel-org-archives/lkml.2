Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0DVNdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:33:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51436 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0DVNdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=MqHkeJaMgKjieT3QwEL5pxlxS8cRKtbpU5SNgQLEh/a8pHBywyX4Vtf15BBhvPvxK6
         dFCMYCj9zz9B47boEZnWIPKg/EXhlV+LopeoSA+1tZ1CBEuowmII+PzaO8AIWMjCEV6J
         2Dppr020rTfhXFF+j1BuxHnYrYvmlNEvV6IgA=
MIME-Version: 1.0
Date: Thu, 22 Apr 2010 09:33:11 -0400
Message-ID: <q2u100eff551004220633s37510b77n235fd5d701b62b9e@mail.gmail.com>
Subject: How to access user level' program in kernel mode?
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In dom0 of XEN, suppose we want to evaluate the I/O request from other
doms using machine learning model, however, this model is written in
user level, how can I do such kind of invocation except rewrite this
model in kernel? Can I use /proc or /sys? Because I need calculate
requests by model and then dispatch them to hard disk.

DomU(send request)-->Dom0(receive request)-->Model analysis
request(user level)-->dispatch request to hard disk

Thanks!

Yuehai
