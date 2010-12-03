Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0LCWDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:03:13 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59392 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0LCWDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:03:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XD4K+TUhTB5Kqhrecljp4rsdJ/98C5VsMzGeGltnSxDNfG41DoP3FQc6Y8o01rWOkY
         Z7U3YslQXDfo3fyUI2ldWKa0oQNd8vBYWepMQocgJbAhC7v5+cYoH0IJRFQTiXCaSBZI
         ZsLQw8Hwep02PjnyZQR66we85AZRzrOeyiPG4=
MIME-Version: 1.0
Date: Fri, 3 Dec 2010 17:03:11 -0500
Message-ID: <AANLkTiko-cby-MBt4nWyeHxfj0ZP6exhWnfrGk08+1iw@mail.gmail.com>
Subject: Are the network namespace patches in?
From: rsa <ravi.mlists@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone know if the network namespace patches by Eric Biederman
are in? More specifically, the patches that addressed the issues related
to opening a socket in a foreign network namespace (using socketat())
etc.

http://kerneltrap.org/mailarchive/linux-kernel/2010/10/27/4637869/thread#mid-4637869

 thank you
rsa
