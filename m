Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1FQFX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:23:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FQFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=hzSxmPJ6UQ8FD163eEEqne/oVDG3vF9Ti/B1NNdywePVsJIdp0cZEpoOq8T7mu/rSh
         oZr5LrLsE7CJodynYsSDKnbn1q+PyXBU7TXdbJPKPjgVIkB2ybjlhPe2JI7cpN45toZK
         EmObqxqvpqW+Nx5jjs3asE3dnlc5EMRH8UoJ8=
Subject: Re: another ext3 kernel BUG
From: Ross Lagerwall <rosslagerwall@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 07:23:13 +0200
Message-ID: <1308288193.17587.3.camel@hobo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See here for a patch:
> https://lkml.org/lkml/2011/6/15/341
> 
> Does that help?

I came across this bug while running ./configure on Octave 3.4.1.

The patch does appear to fix the problem although I can't say whether
what it is doing is correct or not.

There is also a bug report at:
https://bugzilla.kernel.org/show_bug.cgi?id=37602

Cheers
Ross

