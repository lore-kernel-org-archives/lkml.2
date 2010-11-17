Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220Ab0KQSyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:54:13 -0500
Received: from mail.selbetti.com.br ([201.67.157.50]:44959 "EHLO
	mail.selbetti.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935069Ab0KQSyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:54:12 -0500
X-Greylist: delayed 1097 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 13:54:12 EST
Subject: Galbraith patch
From: Gilberto Nunes <gilberto.nunes@selbetti.com.br>
Reply-To: gilberto.nunes@selbetti.com.br
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Selbetti =?ISO-8859-1?Q?Gest=E3o?= de Documentos
Date: Wed, 17 Nov 2010 16:35:47 -0200
Message-ID: <1290018947.4887.14.camel@note-311a>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks...

That is my first post...
I tried compile a vanilla kernel with Galbraith patch, but without
sucess...
When I turn on "Automatic process group scheduling" and try to compile
the kernel, I get this error:

kernel/sched.c: In function ‘sched_init’:
kernel/sched.c:7756: error: implicit declaration of function
‘autogroup_init’
make[1]: ** [kernel/sched.o] Erro 1
make: ** [kernel] Erro 2


Someone know what is wrong here??

Thanks for any help!

Regards


<><

