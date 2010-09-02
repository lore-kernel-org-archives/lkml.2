Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0IBMTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab0IBMTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 08:19:11 -0400
Message-ID: <4C7F9639.7000804@redhat.com>
Date: Thu, 02 Sep 2010 15:19:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: kernelshark plugins and ftrace array fields
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I'd like to add enhance kvm_emulate_insn display in kernelshark to 
show the disassembly of the instruction being emulated.  However, 
pevent_get_field_val() doesn't support arrays (the instruction is 
provided in a 15-byte array).

Can you add support for arrays in the kernelshark API?  With that, it 
looks like adding disassembly output to the kvm plugin should be quite 
simple.

-- 
error compiling committee.c: too many arguments to function

