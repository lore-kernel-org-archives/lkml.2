Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1AOXps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:45:48 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42422 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1AOXpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:45:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=j2ClAlpVFBPhibSbSLPBIWeZg/KFhZTZUIoIIPrJrcHUD3DUS5dbyIct3I1evdPTJp
         KNjSwPT3IcaaJYKmvPkflrroQYoMdO5hk3kieRWUe/IL2UDHyZ/TROKboCWKI0l+R5vR
         OI3nicduc4tFt5aKNuKh+0p2AGgV8H75d1Fo4=
MIME-Version: 1.0
Date: Sat, 15 Jan 2011 16:45:47 -0700
Message-ID: <AANLkTikhCd-ym95_6OLO52WWmiBYoh6CFume5VjNZH+O@mail.gmail.com>
Subject: [ANNOUNCE] Merkey's Linux Kernel Debugger MDB 2.6.37 x86_64
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT
http://merkeydebugger.googlecode.com/files/mdb-2.6.37-x86_64-01-14-2011.patch

REPOSITORY
http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/


FIXES:
- port to 2.6.37 and test
- fix patch delta changes and Fuzz warnings.
- add vt.c vt_msg_redirect() driver location changes

Jeff Merkey
