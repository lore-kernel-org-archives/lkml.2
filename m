Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab1JGRUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:20:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37844 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1JGRUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com>
References: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com>
Date: Fri, 7 Oct 2011 10:20:46 -0700
Message-ID: <CAO3ZPq2RUjW7VQQSoN-S7QDuTYdCMuDfoykHSeXwr19MTnCb_A@mail.gmail.com>
Subject: Re: MODULE_LICENSE("GPL") not working for me
From: Stephen Williams <steveicarus@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 3:30 PM, Stephen Williams <steveicarus@gmail.com> wrote:
> I have some large drivers for use in embedded arm systems, and
> I want them to be GPL, because I want to use some symbols exported
> as GPL, and also because I just wanna. But it is not working for
> me. I've attached my Makefile. I'm building from outside the kernel
> tree, but that should be OK. (right?) I'm using the following script to
> actually build:

More information: I can see that the vidfor.o object file, indeed
none of my *.o files, have a .modinfo section. In other situations
where the licens stamp works, the .modinfo section is present.
I'm using the CodeSourcery build of the arm toolchain, and in
the simple cases (module that is a single source file) the
modinfo information works. Hmm...


-- 
Steve Williams                "The woods are lovely, dark and deep.
steve at icarus.com           But I have promises to keep,
http://www.icarus.com         and lines to code before I sleep,
http://www.picturel.com       And lines to code before I sleep."
