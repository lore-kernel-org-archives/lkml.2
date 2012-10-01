Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2JAJkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:40:08 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44962 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2JAJkH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 1 Oct 2012 05:40:07 -0400
Message-Id: <50698111020000780009EB2E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 01 Oct 2012 10:40:01 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <andrew.cooper3@citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/11] x86/xen: Register resources required by
 kexec-tools
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <20120928162132.GC16262@localhost.localdomain>
In-Reply-To: <20120928162132.GC16262@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.09.12 at 18:21, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Thu, Sep 27, 2012 at 08:06:32PM +0200, Daniel Kiper wrote:
>> +	for (i = 0; i < cpus; ++i) {
> 
> Any specific reason for using '++i' instead of 'i++' ?

For people occasionally also writing C++ code this is the
canonical form.

Jan

