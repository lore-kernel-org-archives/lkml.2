Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0JKPbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:31:24 -0400
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:37011 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0JKPbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:31:23 -0400
X-Greylist: delayed 2188 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 11:31:23 EDT
X-Oleane-Rep: REPA
Message-ID: <4CB32062.7050705@ic.fr>
Date: Mon, 11 Oct 2010 16:34:10 +0200
From: =?ISO-8859-1?Q?C=E9dric_Cano?= <ccano@interfaceconcept.com>
Organization: IC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ccano@interfaceconcept.com, tjourdan@interfaceconcept.com
Subject: Interrupt controller in device modules
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-PMX-Spam: Probability=8%
X-PFSI-Info: PMX 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.10.11.141817 (no antivirus check)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is it possible to create a new interrupt controller in a module that is 
cascaded with another interrupt controller ?
If yes, can the interrupt controller code be independent of the platform 
? Is it then possible to dynamically remove the interrupt controller 
during module unloading ?

Thanks.

CC

