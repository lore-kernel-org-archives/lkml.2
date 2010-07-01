Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0GAFVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:21:49 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:60123 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0GAFVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:21:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: What's the relationship between Linux driver running priority and FIFO policy?
Date: Thu, 1 Jul 2010 13:21:08 +0800
Message-ID: <9BC2BBFFF6E8F04094DB58B805758CE406C039A7@SHAMLVEM01.e2k.ad.ge.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: What's the relationship between Linux driver running priority and FIFO policy?
Thread-Index: AcsY3L61lkwTFNCLRQKBdVk6aK9/IwAAFwSw
From: "Zhang, Yongchao (GE Healthcare)" <Yongchao.Zhang@ge.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Jul 2010 05:21:46.0682 (UTC) FILETIME=[4CE0A1A0:01CB18DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
  I have a question disturb me very much.
  You know linux FIFO policy is common,and also there are many drivers
running in system,so
  which level are these drivers running on? If I have a progrom which
priority is FIFO99, does it disturb the driver running?
  I want know which level does drivers running on? For example, driver
running on FIFOXX? and how does linux schedule on this 
  case?
 
Thanks!
Best Regards!
 
---------------------------
ZhangYongChao
2010.07.01
---------------------------
