Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0IHP2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:28:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34228 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0IHP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:28:13 -0400
From: fabio de francesco <fabio@metanix.org>
Organization: metanix.org
To: LKML <linux-kernel@vger.kernel.org>
Subject: [process scheduler] Possible bug in context_swich()?
Date: Wed, 8 Sep 2010 17:28:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tuxonice-r1-100826; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009081728.18227.fabio@metanix.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List,

My previous mails to you have gone unheard... my last chance...

In context_switch() (in linux/kernel/sched.c), starting with release 2.6.33, 
two "unlikely" macro  have been changed to "likely". I think the previous 
logic was right while the latter is wrong.

In case I am missing something I, please, ask someone to explain the above 
mentioned inversion of logic through releases.

Thanks in advance.

fabio

