Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab0J2QAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab0J2QAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:00:31 -0400
Message-ID: <4CCAEF76.3090708@redhat.com>
Date: Fri, 29 Oct 2010 08:59:50 -0700
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: David Daney <ddaney@caviumnetworks.com>, "H. Peter Anvin" <hpa@zytor.com>,
        rostedt@goodmis.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
References: <cover.1288212485.git.jbaron@redhat.com> <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com> <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com> <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com> <20101028201112.GA4792@redhat.com>
In-Reply-To: <20101028201112.GA4792@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 01:11 PM, Jason Baron wrote:
> I will file one. I did inform Richard Henderson about the bug, and he
> has already developed a fix. I'm not sure yet, when the fix will be
> included in gcc.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=46226

Which also includes a reduced test case.  I'll be checking in the fix
to the relevant branches in a moment.


r~
