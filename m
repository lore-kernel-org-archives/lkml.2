Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0FIBi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:38:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54437 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0FIBi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=BkJAlQRYitBdkOk9/j8VzbTNBjHXXhAnbyyDw5GHGuVLDi2Tckq31jN3HfCTNGXUR7
         EDFDeN7NDKpoEEiVCmzHcaoQDG60N46AFP3vsFB3mzTs+2fM5zo/hz4Iz3cxpX+QHLH9
         ESi+Khmr3o1cqsRiXpLdg+EnUpPyWZT/JfSGA=
MIME-Version: 1.0
Date: Wed, 9 Jun 2010 09:38:25 +0800
Message-ID: <AANLkTik0UvRGmGeZOMaJVaoHk-lv2V8umAF3EIckh9CT@mail.gmail.com>
Subject: When and how to use ftrace?
From: Ryan Wang <openspace.wang@gmail.com>
To: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org,
       srostedt@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

       I'm new to kernel development, and I'm learning
ftrace recently. I have one question:
       When to use ftrace, or in which cases ftrace can be
more efficient?

thanks,
