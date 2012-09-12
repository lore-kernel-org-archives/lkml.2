Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab2ILRDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:03:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52901 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670Ab2ILRDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:35 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Jing Huang <huangj@brocade.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Krishna C Gudipati <kgudipat@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/15] drivers/scsi/bfa: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:09 +0200
Message-Id: <1347469402-27557-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index bcc4966..6a383ba 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -3745,7 +3745,7 @@ bfa_fcs_lport_ns_sm_online(struct bfa_fcs_lport_ns_s *ns,
 			bfa_sm_set_state(ns,
 				bfa_fcs_lport_ns_sm_sending_gid_ft);
 			bfa_fcs_lport_ns_send_gid_ft(ns, NULL);
-		};
+		}
 		break;
 
 	default:
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index fe0463a..5eeddc6 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1301,7 +1301,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 			bfa_timer_start(rport->fcs->bfa, &rport->timer,
 					bfa_fcs_rport_timeout, rport,
 					bfa_fcs_rport_del_timeout);
-		};
+		}
 		break;
 
 	case RPSM_EVENT_DELETE:
@@ -2089,7 +2089,7 @@ bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport)
 		bfa_fcs_itnim_rport_online(rport->itnim);
 		if (!BFA_FCS_PID_IS_WKA(rport->pid))
 			bfa_fcs_rpf_rport_online(rport);
-	};
+	}
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
 	wwn2str(rpwwn_buf, rport->pwwn);

