Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2JOXgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:36:35 -0400
Received: from shiva.jussieu.fr ([134.157.0.129]:51933 "EHLO shiva.jussieu.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2JOXgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:36:33 -0400
X-Ids: 164
From: Juliusz Chroboczek <jch@pps.jussieu.fr>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Write is not atomic?
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
	<CAMo8Bf+w7S_O2XYin7hnuobpBncZxZBq2=nAQ+Jrszif979xKQ@mail.gmail.com>
Date: Tue, 16 Oct 2012 01:36:29 +0200
In-Reply-To: <CAMo8Bf+w7S_O2XYin7hnuobpBncZxZBq2=nAQ+Jrszif979xKQ@mail.gmail.com>
	(Max Filippov's message of "Tue, 16 Oct 2012 02:21:36 +0400")
Message-ID: <7itxtvpate.fsf@lanthane.pps.jussieu.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Miltered: at jchkmail.jussieu.fr with ID 507C9DFE.000 by Joe's j-chkmail (http : // j-chkmail dot ensmp dot fr)!
X-j-chkmail-Enveloppe: 507C9DFE.000/134.157.168.1/hydrogene.pps.jussieu.fr/hydrogene.pps.jussieu.fr/<jch@pps.jussieu.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't check return code here, does write succeed at all?

Yes, both writes return 6.

> Does it ever produce e.g. OuOuilleille

No.

> (as this is what atomicity is about here)?

I was referring to the claim that under Linux writing and adjusting the
file offset are performed as an atomic step, not to the atomicity of the
write operation itself.

-- Juliusz
