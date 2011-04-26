Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1DZL6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:58:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61333 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1DZL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=un80RYBMdeDpYQ3VXkeR6lKUVPfOQ93ze6cDO3A0Stkf7QWsJzOaeetjC9r+OwK88j
         EinNEj4Hq1L0R4PrsG/C9rk2TxkC3DhtRf8A+oQaq6cNP64Kh15kJvUWFVOyg8m59ov0
         J9eq+SCK05VA7v/2+otA7RT0U8ktVMVYtZSdE=
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 14:58:00 +0300
Message-ID: <BANLkTimaJFFCCQOA6=G4i95PsJK_S2bf9Q@mail.gmail.com>
Subject: Why is the 'loff_t *offset' parameter in the file_operations' read
 function a pointer?
From: Amit Ben Shahar <amit.bens@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(if i'm off topic or should look elsewhere i apologize - couldn't find
information anywhere)
I am coding a kernel module and implementing a file's operations, the
read operation received an loff_t *offset parameter, why is this a
pointer? is it in userspace?
