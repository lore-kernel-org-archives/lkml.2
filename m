Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0IMV3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:29:08 -0400
Received: from fmmailgate07.web.de ([217.72.192.248]:54130 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0IMV3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:29:07 -0400
Date: Mon, 13 Sep 2010 23:29:05 +0200 (CEST)
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Message-ID: <1063862301.9960720.1284413345428.JavaMail.fmail@mwmweb063>
Subject: active memory - ok, but per process ?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX1+eLigWZ3vguwDCLmTBjNRnJu1fdbkojFrpEemLj5R2av2sUAF/dsvT
 IXANr7XCNt2gGUtuuuQnrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

pardon - a user question, most likely for vm subsystem experts.
I`m searching for this for a while and don`t know any further.....

as we know  , 

cat /proc/meminfo |grep Active
Active:         139916 
kB

gives the " Memory that has been used more recently and usually not reclaimed unless absolutely necessary."

I wonder - isn`t there a way to break that down on a per-process basis ? (to see which process is the most active memory "consumer")

regards 
Roland﻿
___________________________________________________________
Neu: WEB.DE De-Mail - Einfach wie E-Mail, sicher wie ein Brief!  
Jetzt De-Mail-Adresse reservieren: https://produkte.web.de/go/demail02
