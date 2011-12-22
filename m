Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1LVRwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:52:37 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:62090 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1LVRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:52:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20211.28256.111279.27933@quad.stoffel.home>
Date: Thu, 22 Dec 2011 12:52:32 -0500
From: "John Stoffel" <john@stoffel.org>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
In-Reply-To: <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
	<CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gaurav" == Gaurav Saxena <grvsaxena419@gmail.com> writes:

>> Intercepting system calls is very bad, don't do it.

Gaurav> Oh. I will not do it then, could you suggest me something so
Gaurav> that I could prevent unlink on some file say using kernel
Gaurav> support. I want to save file on unlink how could I do that
Gaurav> without kernel support, or how could I do that using a kernel
Gaurav> module.

Write a FUSE module to mount the filesystem through, inside your FUSE
module you can intercept the unlink/truncate/write calls and decide
what you want to have happen.

John
