Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2GTH7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:59:36 -0400
Received: from canardo.mork.no ([148.122.252.1]:42524 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab2GTH7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:59:34 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: KY Srinivasan <kys@microsoft.com>
Cc: "Greg KH \(gregkh\@linuxfoundation.org\)" 
	<gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the drivers/staging/ directory)
Organization: m
References: <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
	<20111004170415.GA1320@suse.de>
	<6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
	<20111004193414.GA15672@suse.de> <4FFFF711.8040003@redhat.com>
	<426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719210709.GA32031@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF9235475EE@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719220142.GA1513@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120719232832.GA6317@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF9235476BC@SN2PRD0310MB382.namprd03.prod.outlook.com>
Date: Fri, 20 Jul 2012 09:59:01 +0200
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9235476BC@SN2PRD0310MB382.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Fri, 20 Jul 2012 00:41:37 +0000")
Message-ID: <87fw8mlv7e.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KY Srinivasan <kys@microsoft.com> writes:

> Here is the link that describes how the guest ID should be composed:
>
> http://msdn.microsoft.com/en-us/library/windows/hardware/ff542653%28v=vs.85%29.aspx

The unwanted value does not conform to those rules:  Linux is not yet at
major version 0xB5.

I propose that you change this into a macro actually taking the OS
major/minor version into account, keeping the 0xB16B vendor ID (which
seems safest as the vendor ID registration process seems a bit unclear)  


Bjørn
