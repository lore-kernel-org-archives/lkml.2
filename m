Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1DERcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:32:12 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:14002 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab1DERcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:32:08 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        stable <stable@kernel.org>, Mike Surcouf <mike@surcouf.co.uk>
Subject: RE: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Thread-Topic: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Thread-Index: AQHL86xcBVaiLlf0BUaEiRWbBY7rVZRP6XwA//+YKQA=
Date: Tue, 5 Apr 2011 17:32:07 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC03FB0458@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1302020655-27133-1-git-send-email-haiyangz@microsoft.com>
 <20110405162306.GA1800@kroah.com>
In-Reply-To: <20110405162306.GA1800@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 05, 2011 12:23 PM
> Instead, use a proper timer as you do know how long you need to wait,
> right?  Don't abuse workqueues for something they were not designed for.

Thanks for the suggestion, I will add an msleep. And, yes, this delay will
be removed if the Hyper-V side is fixed.

Thanks,
- Haiyang

