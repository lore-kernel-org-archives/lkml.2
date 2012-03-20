Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2CTTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:48:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35707 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756887Ab2CTTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:48:50 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18n2s5JyqwnQvsJU5tXyUTFNuUqO4Fcm0lkDoJOYt
	7sHahjdQ2sT8tW
Message-ID: <4F68D14B.60409@gmx.net>
Date: Tue, 20 Mar 2012 19:49:47 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: bhelgaas@google.com, abelay@mit.edu
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] PNP: Allow PNP resources to be disabled (interface)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody, 

this simple patch series continues the work begun in commit 
18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates 
with empty/disabled resources are handled.  

The aim of this patch series is to allow to set resources as "disabled" using 
the "/sys/bus/pnp/devices/*/resources" interface.  Such "disabled" resources 
are needed by some vintage IBM ThinkPads like the 600E where some resources 
need to have their IRQs disabled in order to support all the devices the 600E
has. 

To this end, some preparatory work is done, simplifying the code and allowing 
for more flexibility in the definition of these resources. 

Here's a brief description of these patches. 

[1/3] - Factor out common some code
[2/3] - Perform the actual setting
[3/3] - Generalize handling of resource flags

The patches are applied against Linux 3.3.x. 

Comments are, as always, welcome.  :-)


--- Witold

