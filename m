Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1CUOQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:16:54 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:16760 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1CUOQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:16:51 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>, Olaf Hering <olaf@aepfle.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv: use sync_bitops when interacting with the hypervisor
Thread-Topic: [PATCH] hv: use sync_bitops when interacting with the
 hypervisor
Thread-Index: AQHL5827+SoLfht7DkyQxOdeamh4eZQ4SOqA//+MZ+A=
Date: Mon, 21 Mar 2011 14:16:49 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC087559@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <20110321134137.GA29305@aepfle.de>
 <20110321140927.GA7358@suse.de>
In-Reply-To: <20110321140927.GA7358@suse.de>
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
> From: Greg KH [mailto:gregkh@suse.de]
> 
> Great!  Can I get an Acked-by from Hank or Haiyang on this as well
> before I apply it?

Our testing team has verified Olaf's fix.
Thanks,

- Haiyang
