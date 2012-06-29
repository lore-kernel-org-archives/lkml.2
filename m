Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab2F2TcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 15:32:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35226 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab2F2Tb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <1340997439.16702.151.camel@gandalf.stny.rr.com>
References: <1340046722-11477-1-git-send-email-vnagarnaik@google.com>
 <1340972741.16702.105.camel@gandalf.stny.rr.com> <1340997439.16702.151.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jun 2012 12:31:27 -0700
Message-ID: <CAL26m8KFOAic=_VRy0uNoLySVwxb8k1q+ywA9EmKzhEjrQnT=A@mail.gmail.com>
Subject: Re: [PATCH] tracing: Update entries counter when removing pages
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 12:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-06-29 at 08:25 -0400, Steven Rostedt wrote:
>> Actually, I think it would be better to increment overrun instead. As
>> these are lost events, and that is what overrun counts. I just tested it
>> with: local_add(page_entries, &cpu_buffer->overrun); and it works well.
>> Showing the lost events.
>
> Can you make this change and repost the patch. I'll start testing it if
> you can ASAP. Otherwise it will have to wait till next week.
>

I was just testing the change. I am sending the new patch.


Vaibhav Nagarnaik
