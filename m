Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2EKUHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:07:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42230 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab2EKUHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:07:37 -0400
MIME-Version: 1.0
In-Reply-To: <4FAD6012.20408@redhat.com>
References: <1336683628-12954-1-git-send-email-mchehab@redhat.com>
	<1336748054-21325-1-git-send-email-mchehab@redhat.com>
	<3908561D78D1C84285E8C5FCA982C28F192ED5D3@ORSMSX104.amr.corp.intel.com>
	<4FAD6012.20408@redhat.com>
Date: Fri, 11 May 2012 13:07:36 -0700
X-Google-Sender-Auth: ngChOtw9bmMrdFWIk-6TCJ4NOj4
Message-ID: <CA+8MBbJ4K5HagC6s-Swtb-DUoUv8rR7YuoshQgedDLx8Vfz6VQ@mail.gmail.com>
Subject: Re: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
From: Tony Luck <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:53 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> With the current implementation, this can actually be done at driver-basis: just fill
> error_msg with a blank string and add all details at the driver-specific error detail.

Cool. Then we just need some documentation telling EDAC driver
writers that error_msg is only intended for information that will help
a casual user understand what (if anything) to do about the error.

-Tony
