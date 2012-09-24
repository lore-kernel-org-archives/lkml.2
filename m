Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2IXXrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:47:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2IXXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:47:39 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=yMNniWiJskoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ptxN4nHB2WUA:10 a=9IqdHngFs5eNX8id4XIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348530457.22822.6.camel@gandalf.local.home>
Subject: Re: [PATCH v4] trace: Move trace event enable from fs_initcall to
 core_initcall
From: Steven Rostedt <rostedt@goodmis.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>
Date: Mon, 24 Sep 2012 19:47:37 -0400
In-Reply-To: <CALF0-+UequmiTTPi9RnYjEkBeW1mtxpS-fDiXLnfgwjG8UWGdQ@mail.gmail.com>
References: <1347461277-25302-1-git-send-email-elezegarcia@gmail.com>
	 <CALF0-+UequmiTTPi9RnYjEkBeW1mtxpS-fDiXLnfgwjG8UWGdQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 14:23 -0300, Ezequiel Garcia wrote:

> Did you have time to take a look into this?
> Will you be able to add it for your v3.7 pull request?
> Let me know if there's something I should redo.

Yeah, I have it queued up for my test set of tests. If it passes, I'll
push it towards Ingo. Maybe it's not too late for 3.7.

-- Steve


