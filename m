Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2IUScs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:32:48 -0400
Received: from emailgw01.pnnl.gov ([192.101.109.61]:9561 "EHLO
	Emailgw01.pnnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2IUSco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:44 -0400
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 14:32:44 EDT
From: "Fox, Kevin M" <kevin.fox@pnnl.gov>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Sep 2012 10:32:36 -0700
Subject: Conditional Unlink
Thread-Topic: Conditional Unlink
Thread-Index: AQHNmB5co6lrxY3v1kecYyC3pk+LIQ==
Message-ID: <81A22C12505EF7419E792D791BC28B3C0104E178E598@EMAIL05.pnl.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick question:
Is there a syscall or some algorithm that would allow an unlink that would only happen if no writes to the file have occurred between a stat and an unlink, race free?

Background:
I'm writing a program that sync's files up to a server. I would like to unlink the files that have successfully been uploaded. There is a race though. If the file changed after uploading but before the unlink (I do not control who can write to the files), the next upload should take care of things and the unlink should fail. Otherwise, data could be lost!

Thanks,
Kevin
