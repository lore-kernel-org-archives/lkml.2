Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1BIQbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:31:23 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53642 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1BIQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=tDexKwmK/r2Jh3zskJ1e34gxp+SxU2VB33rqNEx35M4MfttTtmZ1MmCX2nyMQixG3X
         2aEjI0nYVz73PcHMMPt7qDra9+qyZENSV8y1axnki7mM2Pz/oOSP8pAkJ+EFdJyBjzZ0
         ncY1CjLeVb2tBeVfLiTTW78kWDd7oVpMaLlyc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 9 Feb 2011 17:31:21 +0100
Message-ID: <AANLkTi=w-kFhUUxf+GjoWoOZr6F_3Z2xb-vg_=QN8FGX@mail.gmail.com>
Subject: [PatchWork] DatabaseError at /project/LKML/list/
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error_message looks like this:

DatabaseError at /project/LKML/list/

(145, "Table './patchwork/patchwork_patch' is marked as crashed and
should be repaired")

Request Method: 	GET
Request URL: 	https://patchwork.kernel.org/project/LKML/list/
Django Version: 	1.2.4
Exception Type: 	DatabaseError
Exception Value: 	

(145, "Table './patchwork/patchwork_patch' is marked as crashed and
should be repaired")

Exception Location:
	/usr/lib64/python2.7/site-packages/MySQLdb/connections.py in
defaulterrorhandler, line 36
Python Executable: 	/usr/bin/python
Python Version: 	2.7.0
Python Path: 	['/var/www/patchwork/apps', '/var/www/patchwork',
'/var/www/patchwork/lib/python', '/usr/lib64/python27.zip',
'/usr/lib64/python2.7', '/usr/lib64/python2.7/plat-linux2',
'/usr/lib64/python2.7/lib-tk', '/usr/lib64/python2.7/lib-old',
'/usr/lib64/python2.7/lib-dynload',
'/usr/lib64/python2.7/site-packages',
'/usr/lib64/python2.7/site-packages/Numeric',
'/usr/lib64/python2.7/site-packages/PIL',
'/usr/lib64/python2.7/site-packages/gtk-2.0',
'/usr/lib/python2.7/site-packages',
'/usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info']
Server time: 	Wed, 9 Feb 2011 16:30:09 +0000
- EOT -
