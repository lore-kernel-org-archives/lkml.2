Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0EIWr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:47:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34651 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0EIWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=etms5wFuSUEshORh9I3M40RJIX3zQlQdz5O0p504No30qh1peINzy6qF5PT7VRQXAp
         ee1ZgqGQo2OliQCjtfEb3umcU4+wskzNKHTvWrhFVrkXKu0xuiid7t5P3ocrd6n4ctvk
         L1jbC2o/aE+43iMw7wPjHibwRaIWBbpL314ZA=
MIME-Version: 1.0
Date: Mon, 10 May 2010 00:47:23 +0200
Message-ID: <AANLkTikTPkLID3e8HpT1jMeiF9tQ6-7oJWQBfiRF7xUN@mail.gmail.com>
Subject: May the worker function free its struct_work (plus container)?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

may the worker function kfree() it's own work data structure?

/* worker function */
static void engine_service_work(struct work_struct *work)
{
  struct  foobar_container_struct *foobar;
  foobar = container_of(work, struct foobar, work);
  /* ...perform some work... */
  kfree(foobar);
}

Thanks,
-- 
Leon
