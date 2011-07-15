Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297Ab1GOIcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:32:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:63553 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045Ab1GOIck convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 15 Jul 2011 04:32:40 -0400
Message-Id: <4E201743020000780004D8B8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 15 Jul 2011 09:32:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <Ian.Campbell@citrix.com>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <keir@xen.org>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on
	 resume
References: <4E1DB9C70200007800072DCC@nat28.tlf.novell.com>
 <20110714102628.GA9157@aepfle.de>
In-Reply-To: <20110714102628.GA9157@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.07.11 at 12:26, Olaf Hering <olaf@aepfle.de> wrote:
> On Wed, Jul 13, Jan Beulich wrote:
> 
>> >>> Ian Campbell <Ian.Campbell@citrix.com> 07/13/11 11:12 AM >>>
>> >It's not so much an objection to this patch but this issue seems to have
>> >been caused by Xen cset 20892:d311d1efc25e which looks to me like a
>> >subtle ABI breakage for guests. Perhaps we should introduce a feature
>> >flag to indicate that a guest can cope with the m2p changing size over
>> >migration like this?
>> 
>> Indeed - migration was completely beyond my consideration when
>> submitting this. A feature flag seems the right way to go to me.
> 
> I will prepare a patch for a new feature flag.

Let me fold this into the feature handling change patch I'm close
to submit - without those changes I don't think a guest kernel would
have a way to actually announce its capability.

Jan

