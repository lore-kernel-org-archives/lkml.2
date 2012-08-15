Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2HOJ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2HOJ4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:56:38 -0400
Date: Wed, 15 Aug 2012 12:56:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Yan Vugenfirer <yvugenfi@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is
 panicked
Message-ID: <20120815095630.GT11194@redhat.com>
References: <5021D235.4050800@cn.fujitsu.com>
 <20120813182132.GB25268@amt.cnet>
 <20120814085619.GA32708@redhat.com>
 <502A2B7A.3070801@siemens.com>
 <86E2467F-0EA3-4A03-BD89-58E41F7DB808@redhat.com>
 <20120814154237.GA21284@amt.cnet>
 <87boidgvaq.fsf@codemonkey.ws>
 <20120814191927.GA6058@amt.cnet>
 <87txw5clmh.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txw5clmh.fsf@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:35:34PM -0500, Anthony Liguori wrote:
> > Do you consider allowing support for Windows as overengineering?
> 
> I don't think there is a way to hook BSOD on Windows so attempting to
> engineer something that works with Windows seems odd, no?
> 
Yan says in other email that is is possible to register a bugcheck callback.

--
			Gleb.
