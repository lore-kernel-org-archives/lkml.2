Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1LVQI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:08:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38980 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1LVQIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:08:24 -0500
MIME-Version: 1.0
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Thu, 22 Dec 2011 21:37:53 +0530
Message-ID: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
Subject: Intercepting system calls
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am writing an application for which I need to intercept some
filesystem system calls eg. unlink. I need unlink to call my code
before deleting abc so that I could probably prevent unlink . I would
like to implement this in a kernel module instead of modifying kernel
code itself. I would like to intercept system calls by replacing
system calls but I have not been able to find any method of doing that
in linux > 3.0. Please suggest some method of doing that.


--
Thanks and Regards ,
Gaurav
