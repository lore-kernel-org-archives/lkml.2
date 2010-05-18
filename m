Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0ERSur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:50:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53478 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0ERSuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:50:46 -0400
Message-ID: <4BF2E0A2.6030209@zytor.com>
Date: Tue, 18 May 2010 11:46:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>> <87tyq9mqrz.fsf@basil.nowhere.org>> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>> <20100515121424.38f5b389@infradead.org>> <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>> <20100515224305.17a04022@infradead.org>> <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>> <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>> <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>> <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>> <4BF2C30F.6030502@zytor.com> <1274201536.5605.8347.camel@twins 4BF2C881.60807@zytor.com> <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default>
In-Reply-To: <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 10:49 AM, Dan Magenheimer wrote:
> 
> (Though I expect tglx/arjan/andi/mingo to disagree with this proposal
> for similar reasons as the original one that started this thread...)
> 

I'll add another reason to disagree: exporting these as sysfs variables
is non-atomic, but these are really only useful when atomically read as
a unit.

	-hpa
