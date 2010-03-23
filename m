Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0CWJog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:44:36 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:41567 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753740Ab0CWJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:44:35 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2010 05:44:34 EDT
Subject: Usage of checkpatch.pl for other projects
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@fifo99.com>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 10:37:54 +0100
Message-ID: <1269337074.12129.4674.camel@korcula.inria.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I saw the very interesting presentation of Greg at the last FOSDEM where
he explained how to write a patch of the kernel. 

During his presentation, he presented the script checkpatch.pl which
checks the coding style of a patch / file. 

For a while, I have been looking for such script which can check the
compliance of a source code against a coding policy.

Obviously, the coding style of my project is not exactly the same as he
Kernel one. 

Therefor, I would like to know if there is any plan of making a
dedicated project of this piece of software to allow usage of it for
other projects.
If it is not the case, is it possible to contribute to change the
behavior of the policy check (of course, disable by default for kernel
hackers) ?

Thanks,
Sylvestre


