Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449Ab0J1Szv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:55:51 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11870 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432Ab0J1Szl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:55:41 -0400
Message-ID: <4CC9C724.3020004@caviumnetworks.com>
Date: Thu, 28 Oct 2010 11:55:32 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>, rth@redhat.com
CC: "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
References: <cover.1288212485.git.jbaron@redhat.com> <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com> <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com> <20101028141757.GA2875@redhat.com>
In-Reply-To: <20101028141757.GA2875@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 18:56:06.0671 (UTC) FILETIME=[C6DB89F0:01CB76D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 07:17 AM, Jason Baron wrote:
> On Wed, Oct 27, 2010 at 03:21:55PM -0700, H. Peter Anvin wrote:
>> Could you detail the bug, please?  static_cpu_has() also uses asm goto.
>>
>
> It seems that gcc can leave the stack in an inconsistent state.
>
> I only saw this in the 'jmp' enabled case, I'm not sure if it can occur in the
> straight-line code path as well.
>

Jason,

Were you going to file a GCC bug on this issue?  Someone should.

It would be a shame to have the problem persist due to lack of awareness 
by the GCC developers.

David Daney
