Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0K2MhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:37:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37809 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0K2MhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FU+3zqnXWCgSJ1ALViGKX6UQdsfgzBroL8LXEdnFq56D6EsrHE54kw0FWA1cDN1MkO
         sI5xk9AStqNTnOMGrKA1bMn+ij2u8rBn5cgcE8ZNWYjZsBt2EbJpOLbLivorbHYjWHhA
         65FIWLl2iUx2QUuEHroyNgoxYP+uJGWT5S8yA=
MIME-Version: 1.0
Date: Mon, 29 Nov 2010 13:37:17 +0100
Message-ID: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
Subject: Atomic non-durable file write API
From: Olaf van der Spek <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the introduction of ext4, some apps/users have had issues with
file corruption after a system crash. It's not a bug in the FS AFAIK
and it's not exclusive to ext4.
Writing a temp file, fsync, rename is often proposed. However, the
durable aspect of fsync isn't always required and this way has other
issues.
What is the recommended way for atomic non-durable (complete) file writes?

I'm also wondering why FSs commit after open/truncate but before
write/close. AFAIK this isn't necessary and thus suboptimal.

Greetings,

Olaf
