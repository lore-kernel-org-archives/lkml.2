Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1LFA1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:27:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47395 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab1LFA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:27:40 -0500
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be
Subject: [PATCH] hpwd watchdog mark page executable 
Date: Mon,  5 Dec 2011 16:25:38 -0800
Message-Id: <1323131139-32451-1-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EDD617A.008F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Of course set up executable flag. Not writable :)

