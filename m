Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0G2O0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:26:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49362 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab0G2O0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=qqZhCii0uDKfuDfhQ+RgEym6Wyt+c52YvF0qaiCTYz0+s+68P3CjKnF8PgcZ7QPxun
         O7XVXgQ+g87HO3AcBbxOzPlu34ILDdpmYIxc3rf+KajCOMh4KoTX72K+2aA1yypWYbs8
         mbK36sOAZjQV2JJCwkKcLxBUw9zaaAtQ5ed64=
MIME-Version: 1.0
Date: Thu, 29 Jul 2010 17:25:53 +0300
Message-ID: <AANLkTinv8Ktf6BeGCNo6RkAHmD3-Ey20vHF1ycy025uR@mail.gmail.com>
Subject: 2.6.36/37 suggestion
From: Oleksandr Natalenko <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In reply to Ted Tso
(http://article.gmane.org/gmane.linux.kernel/1008643) I would like to
suggest kernel developers (first of all, Linus) some kind of
compromise. Let's prohibit accepting new features during 2.6.36 merge
window and accept only bugfixes until bugzilla and regression lists
are empty. For drivers subsystem you may create separate branch and
accept all changes there, then merge them into 2.6.37.

It should resolve "features vs stability" problem for now.
