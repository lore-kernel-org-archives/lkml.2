Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0C3QHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:07:25 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49190 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab0C3QHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=h2t9zdpotvJcD/fOYw/irXCr2n/Bq6lAGSOQM/zrx7uKcdLkvAuh0CsS4tbKdcYjke
         CsgpW7q9ftT3fhAZJuQ0KxqC2o4nQ67iDFzAstGMveOd7SYXOqQwd97pIW6bWVJ+JyMy
         GQD0RyrCdnl6OneyugVYoxUGSCypqJOrcNEgI=
MIME-Version: 1.0
Date: Tue, 30 Mar 2010 19:07:18 +0300
Message-ID: <912ec82a1003300907o7edeb73bp92d56741cfee1064@mail.gmail.com>
Subject: pr_* versus dev_*
From: Neshama Parhoti <pneshama@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which set of macros should I use in my driver ?

pr_info, pr_err, etc...  or dev_info, dev_err,    etc. ?

what are the advantages of the dev_* macros over the pr_* macros
(why does it take the device pointer as an argument) ?

obviously I don't have access to my device pointer in all my functions..
so pr_info is easier to use..
but if it's wanted, obviously I can arrange to have my device pointer
accessible..

thank you
~pnesh
