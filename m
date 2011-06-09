Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1FIRLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:11:38 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:48703 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1FIRLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:11:36 -0400
X-AuditID: 83cfa826-b7c5dae0000046d4-cc-4df0fec65f89
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <keithp@keithp.com>, <johan.hedberg@gmail.com>
CC: <padovan@profusion.mobi>, <marcel@holtmann.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 9 Jun 2011 20:11:21 +0300
Subject: RE: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Thread-Topic: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Thread-Index: AcwmxuAZ1bPeo42oQYuSgQdGD9srIgAAFofw
Message-ID: <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com>
References: <yunboy7a2so.fsf@aiko.keithp.com>
 <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com>
 <20110609083345.GA2894@dell.ccr.corp.intel.com>
 <yuny61b3pnm.fsf@aiko.keithp.com>
In-Reply-To: <yuny61b3pnm.fsf@aiko.keithp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith, 

>I re-pair'ed using a manually entered a 16 digit pin, but now 
>DUN setup doesn't succeed at all.

Did you try to remove all stored link keys and start again?
If you already have a pincode which is insecure you have to remove it manually.

Try 'hciconfig hciX noauth noencrypt ' before.

Check syslog and switch debug on in the kernel first.


Waldek


