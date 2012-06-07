Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab2FGKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:50:21 -0400
Received: from canardo.mork.no ([148.122.252.1]:41715 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2FGKuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:50:19 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 02/13] code cleanup
Organization: m
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
	<1339057243-10029-3-git-send-email-stefani@seibold.net>
	<877gvjtrsf.fsf@nemi.mork.no> <1339060906.11583.9.camel@wall-e>
Date: Thu, 07 Jun 2012 12:49:49 +0200
In-Reply-To: <1339060906.11583.9.camel@wall-e> (Stefani Seibold's message of
	"Thu, 07 Jun 2012 11:21:46 +0200")
Message-ID: <87vcj3s8fm.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:

> If it is necessary...

So, why is it necessary for you to change this code *from* the style
recommended by CodingStyle and LDD3?

Quoting from LDD3:

 "Error recovery is sometimes best handled with the goto statement. We
  normally hate to use goto, but in our opinion, this is one situation
  where it is useful. Careful use of goto in error situations can
  eliminate a great deal of complicated, highly-indented, "structured"
  logic. Thus, in the kernel, goto is often used as shown here to deal
  with errors."

> Compacting improves since it will make the code more readable.

No, it does not.  As pointed out, instead of having to follow a single
exit path from each function, your changes makes it necessary to follow
n exit paths.  That does not make the code more readable, and it
contradicts both CodingStyle and LDD3.

Note that I am not stating in any way that those documents contain
absolute truths and that you cannot write your own driver the way you
like.  I do however find it extremely strange that you insist on
changing a coding example to be inconsistent with those documents.
Regardless of whether you agree with them or not, you must see that such
inconsistent guidelines will be a problem for anyone trying to use this
code for learning?


Bjørn
