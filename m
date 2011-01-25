Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1AYFc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:32:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56544 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1AYFc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=s6PDqxACQhEEVtfPJVcOqVKB5+5SybZcRDcUbXJUGXveoX8E6gdGuKG/+HBjy1aRVN
         vPvn5G1YHuhYEItPpdXeuyDSXxZa2rBsABGmA182/0RG8LbJ3/e8nJBXFsfpNtC7lE8U
         OnMBaa8BvyEuA/Crg3ssnrt8LA2x5NcIs8h3g=
MIME-Version: 1.0
From: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Date: Tue, 25 Jan 2011 11:02:07 +0530
Message-ID: <AANLkTi=ihFQabYs1k=9Eho5D1pV9kwNjZzErBt=MpEdV@mail.gmail.com>
Subject: IPv6 stack initialization
To: linux-kernel@vger.kernel.org
Cc: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I am working on a kernel loadable module which is loaded during the
bootup. This module triggers IPv6 'send's in its initialization
function. I am observing that few (upto 5) initial IPv6 'send's are
failing with "Network Unreachable" error. And then it starts working
fine. So my question is, is there any way to find out if the IPv6
stack is ready to use before doing any IPv6 transmission ?

Thanks.

PS: Please CC your responses to my e-mail ID.

-- 
Keshetti Mahesh
