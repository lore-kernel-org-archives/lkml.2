Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1G0R22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:28:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41822 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1G0R2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-rk0uuRcVDDkAbNRBOhXBUyFOF8MqaUWfueP2C0=SeOXQ@mail.gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-17-git-send-email-jim.cromie@gmail.com> <CAO+b5-rk0uuRcVDDkAbNRBOhXBUyFOF8MqaUWfueP2C0=SeOXQ@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 27 Jul 2011 11:27:54 -0600
Message-ID: <CAJfuBxwXcbVzOJ+0_YB8sXBxyw62T2aXJ7Vr4U=9WLE6R1iz1g@mail.gmail.com>
Subject: Re: [PATCH 16/25] dynamic_debug: require 'a' flag to explicitly mark
 pending queries
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:26 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> +       if (!q1->module ^ !q2->module ||
>> +               !q1->filename ^ !q2->filename ||
>> +               !q1->function ^ !q2->function ||
>> +               !q1->format ^ !q2->format)
>> +               return false;  /* a match-spec set/unset state differs */
>
> I'd suggest to use "!=" here instead of "^" when testing booleans for
> inequality. At least for me that would make the above code easier to
> read.
>
> Bart.
>

yes. ^ is esoteric compared to !=
my github tree updated accordingly,
git://github.com/jimc/linux-2.6.git  dyndbg-next
